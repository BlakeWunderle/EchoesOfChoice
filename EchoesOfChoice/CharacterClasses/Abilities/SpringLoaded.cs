using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class SpringLoaded : Ability
    {
        public SpringLoaded()
        {
            Name = "Spring Loaded";
            FlavorText = "Launch an enemy violently and wait for their screams to stop when they hit the ground.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}

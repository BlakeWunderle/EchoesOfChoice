using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Protect : Ability
    {
        public Protect()
        {
            Name = "Protect";
            FlavorText = "Raises a teammate's defenses to help in battle. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 2;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}

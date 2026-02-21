using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Knockdown : Ability
    {
        public Knockdown()
        {
            Name = "Knockdown";
            FlavorText = "Blow your enemy over. Decreases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}

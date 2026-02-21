using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Cure : Ability
    {
        public Cure()
        {
            Name = "Cure";
            FlavorText = "Restore health to a teammate.";
            ModifiedStat = StatEnum.Health;
            Modifier = 3;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 7;
        }
    }
}

using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Lullaby : Ability
    {
        public Lullaby()
        {
            Name = "Lullaby";
            FlavorText = "Your song puts your opponent to sleep. Decreases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}

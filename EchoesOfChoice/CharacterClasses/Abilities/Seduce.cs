using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Seduce : Ability
    {
        public Seduce()
        {
            Name = "Seduce";
            FlavorText = "Charm the enemy and lower their defenses. Lowers defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}

using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Inscribe : Ability
    {
        public Inscribe()
        {
            Name = "Inscribe";
            FlavorText = "A protective rune is traced in the air, forming a shimmering ward around an ally.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
